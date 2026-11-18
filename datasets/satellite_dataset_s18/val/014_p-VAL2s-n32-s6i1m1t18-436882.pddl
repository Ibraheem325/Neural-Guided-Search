(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	spectrograph0 - mode
	GroundStation1 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation17 - direction
	GroundStation15 - direction
	Star5 - direction
	GroundStation16 - direction
	Star8 - direction
	GroundStation2 - direction
	Star14 - direction
	GroundStation13 - direction
	GroundStation12 - direction
	Star10 - direction
	GroundStation7 - direction
	Star0 - direction
	Star11 - direction
	GroundStation9 - direction
	Phenomenon18 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star14)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation15)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star14)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation15)
	(calibration_target instrument2 GroundStation16)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 GroundStation12)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation7)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star14)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 GroundStation16)
	(calibration_target instrument3 Star5)
	(calibration_target instrument3 GroundStation15)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star3)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 GroundStation12)
	(calibration_target instrument4 GroundStation13)
	(calibration_target instrument4 Star14)
	(calibration_target instrument4 GroundStation2)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation2)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation9)
	(calibration_target instrument5 Star11)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation7)
	(calibration_target instrument5 Star10)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Star14)
)
(:goal (and
	(pointing satellite0 GroundStation16)
	(pointing satellite2 Star5)
	(pointing satellite3 Star10)
	(pointing satellite4 GroundStation9)
	(have_image Phenomenon18 spectrograph0)
))

)
