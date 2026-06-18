(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	spectrograph2 - mode
	infrared5 - mode
	infrared3 - mode
	spectrograph0 - mode
	spectrograph6 - mode
	spectrograph1 - mode
	thermograph4 - mode
	Star1 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation4 - direction
	GroundStation12 - direction
	Star7 - direction
	GroundStation11 - direction
	Star13 - direction
	Star0 - direction
	Star5 - direction
	Star2 - direction
	GroundStation3 - direction
	Star6 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 infrared5)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation4)
	(supports instrument1 spectrograph6)
	(supports instrument1 spectrograph2)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star2)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 Star13)
	(calibration_target instrument2 GroundStation11)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
)
(:goal (and
	(pointing satellite0 GroundStation8)
	(have_image Star14 spectrograph0)
	(have_image Star15 spectrograph1)
	(have_image Planet16 spectrograph2)
	(have_image Planet16 thermograph4)
	(have_image Planet17 spectrograph1)
	(have_image Planet17 spectrograph2)
))

)
