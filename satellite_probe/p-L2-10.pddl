(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	spectrograph2 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	GroundStation3 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation1 - direction
	GroundStation7 - direction
	Star0 - direction
	Star2 - direction
	GroundStation14 - direction
	GroundStation10 - direction
	Star5 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Planet17 - direction
	Star18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Planet21 - direction
	Planet22 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation4)
	(supports instrument1 spectrograph1)
	(supports instrument1 spectrograph2)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation14)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star18)
	(supports instrument2 spectrograph1)
	(supports instrument2 spectrograph2)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 Star5)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon16)
)
(:goal (and
	(pointing satellite0 GroundStation4)
	(pointing satellite1 Phenomenon16)
	(have_image Planet15 spectrograph1)
	(have_image Phenomenon16 spectrograph2)
	(have_image Planet17 spectrograph0)
	(have_image Star18 spectrograph2)
	(have_image Phenomenon19 spectrograph0)
	(have_image Planet20 spectrograph2)
	(have_image Planet21 spectrograph0)
	(have_image Planet22 spectrograph2)
))

)
