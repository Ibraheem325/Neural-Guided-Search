(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	satellite5 - satellite
	instrument6 - instrument
	satellite6 - satellite
	instrument7 - instrument
	instrument8 - instrument
	satellite7 - satellite
	instrument9 - instrument
	spectrograph0 - mode
	GroundStation6 - direction
	Star17 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	Star9 - direction
	Star22 - direction
	Star8 - direction
	Star2 - direction
	GroundStation12 - direction
	Star20 - direction
	GroundStation0 - direction
	Star7 - direction
	Star13 - direction
	Star11 - direction
	GroundStation5 - direction
	GroundStation19 - direction
	Star4 - direction
	GroundStation10 - direction
	GroundStation14 - direction
	Star15 - direction
	Star18 - direction
	Star21 - direction
	GroundStation16 - direction
	Star23 - direction
	Star24 - direction
	Planet25 - direction
	Planet26 - direction
	Planet27 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation12)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 Star2)
	(calibration_target instrument2 Star18)
	(calibration_target instrument2 Star20)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star15)
	(calibration_target instrument2 GroundStation12)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star15)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 GroundStation14)
	(calibration_target instrument3 Star21)
	(calibration_target instrument3 GroundStation1)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation10)
	(supports instrument4 spectrograph0)
	(calibration_target instrument4 Star18)
	(calibration_target instrument4 Star22)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 Star20)
	(calibration_target instrument4 Star11)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star2)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 Star8)
	(calibration_target instrument5 GroundStation10)
	(calibration_target instrument5 Star2)
	(calibration_target instrument5 Star15)
	(on_board instrument5 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation19)
	(supports instrument6 spectrograph0)
	(calibration_target instrument6 GroundStation0)
	(calibration_target instrument6 Star20)
	(calibration_target instrument6 GroundStation12)
	(calibration_target instrument6 Star2)
	(calibration_target instrument6 Star8)
	(on_board instrument6 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation3)
	(supports instrument7 spectrograph0)
	(calibration_target instrument7 Star4)
	(calibration_target instrument7 Star7)
	(calibration_target instrument7 Star15)
	(supports instrument8 spectrograph0)
	(calibration_target instrument8 GroundStation10)
	(calibration_target instrument8 Star4)
	(calibration_target instrument8 GroundStation19)
	(calibration_target instrument8 GroundStation5)
	(calibration_target instrument8 Star11)
	(calibration_target instrument8 Star13)
	(on_board instrument7 satellite6)
	(on_board instrument8 satellite6)
	(power_avail satellite6)
	(pointing satellite6 Star4)
	(supports instrument9 spectrograph0)
	(calibration_target instrument9 GroundStation16)
	(calibration_target instrument9 Star21)
	(calibration_target instrument9 Star18)
	(calibration_target instrument9 Star15)
	(calibration_target instrument9 GroundStation14)
	(on_board instrument9 satellite7)
	(power_avail satellite7)
	(pointing satellite7 GroundStation12)
)
(:goal (and
	(pointing satellite1 Star21)
	(pointing satellite5 Star8)
	(pointing satellite7 Star22)
	(have_image Star23 spectrograph0)
	(have_image Star24 spectrograph0)
	(have_image Planet25 spectrograph0)
	(have_image Planet26 spectrograph0)
	(have_image Planet27 spectrograph0)
))

)
